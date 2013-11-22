Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:35510 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab3KVRQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 12:16:55 -0500
Message-ID: <528F8FED.6030301@erley.org> (sfid-20131122_181658_771722_5091F8AE)
Date: Fri, 22 Nov 2013 11:10:05 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: shankar swaminathan <shankswa@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [hostapd] configuring for a simple AP
References: <CADNhdGFPR6JOkZjDMMZ7mEo5cJdBrg9a300A4pS=e_WGMdNpbA@mail.gmail.com> <CADNhdGGusDJNkh1j3mS+bdLuJS4S2vC9YD+zU5tLOfg7YPJSDw@mail.gmail.com>
In-Reply-To: <CADNhdGGusDJNkh1j3mS+bdLuJS4S2vC9YD+zU5tLOfg7YPJSDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2013 01:13 AM, shankar swaminathan wrote:
> Hello,
>
> it would be of great help if someone could throw some light regarding
> the hostapd issue that I have described in the below email.
>
> thanks and regards,
> -shankar
>
>
> On Thu, Nov 21, 2013 at 7:11 PM, shankar swaminathan <shankswa@gmail.com> wrote:
>> Hi,
>>
>> I am trying to make a linux PC up and running with hostapd to create a
>> simple Access Point.
>>
>> I do not want authentication, encryption and DHCP -- have configured
>> station with static IP address.
>>
>> if I start hostapd (not as a daemon) with the default hostapd.conf
>> file, and try connecting the client (fedora client), i see that the
>> wifi sybol does not appear, but the connection seems to have been
>> established.
>> However, if i open hostapd_cli, i keep getting a print like,
>> <client mac> CONNECTED
>> <client mac> DISCONNECTED.
>>
>> Hence, i think the client keeps getting connected and disconnected.
>>
>> I then tried using a smaller config file with nothing regarding beacon
>> interval etc...as shown below:
>>
>> ---
>> interface=wlan0
>> driver=nl80211
>> ssid=test
>> hw_mode=g
>> channel=1
>> macaddr_acl=0
>> auth_algs=1
>> ignore_broadcast_ssid=0
>> ---
>>
>> The results were similar.
>>
>> Could anyone, guide me or provide me a simple hostapd.conf file, that
>> will help me connect clients. I do not want authentication,
>> encryption, and DHCP -- will use static IP.
>>
>> Thanks in advance.
>>
>> -shankar

What device/driver are you using?  What kind of client is connecting? 
Is the client indicating it's been disconnected by the AP, or is the 
client seeing that it's not getting an IP address and disconnecting of 
its own choosing?

http://wireless.kernel.org/en/users/Documentation/hostapd has a great 
example of how to get an access point up and running.

for anyone to help, actual hostapd/client output(with little to no 
editing) will be needed.

