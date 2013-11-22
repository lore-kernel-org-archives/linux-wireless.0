Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35587 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3KVHN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 02:13:58 -0500
Received: by mail-wg0-f54.google.com with SMTP id y10so761203wgg.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 23:13:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADNhdGFPR6JOkZjDMMZ7mEo5cJdBrg9a300A4pS=e_WGMdNpbA@mail.gmail.com>
References: <CADNhdGFPR6JOkZjDMMZ7mEo5cJdBrg9a300A4pS=e_WGMdNpbA@mail.gmail.com>
Date: Fri, 22 Nov 2013 12:43:57 +0530
Message-ID: <CADNhdGGusDJNkh1j3mS+bdLuJS4S2vC9YD+zU5tLOfg7YPJSDw@mail.gmail.com> (sfid-20131122_081407_719145_5AF9FCEE)
Subject: Re: [hostapd] configuring for a simple AP
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

it would be of great help if someone could throw some light regarding
the hostapd issue that I have described in the below email.

thanks and regards,
-shankar


On Thu, Nov 21, 2013 at 7:11 PM, shankar swaminathan <shankswa@gmail.com> wrote:
> Hi,
>
> I am trying to make a linux PC up and running with hostapd to create a
> simple Access Point.
>
> I do not want authentication, encryption and DHCP -- have configured
> station with static IP address.
>
> if I start hostapd (not as a daemon) with the default hostapd.conf
> file, and try connecting the client (fedora client), i see that the
> wifi sybol does not appear, but the connection seems to have been
> established.
> However, if i open hostapd_cli, i keep getting a print like,
> <client mac> CONNECTED
> <client mac> DISCONNECTED.
>
> Hence, i think the client keeps getting connected and disconnected.
>
> I then tried using a smaller config file with nothing regarding beacon
> interval etc...as shown below:
>
> ---
> interface=wlan0
> driver=nl80211
> ssid=test
> hw_mode=g
> channel=1
> macaddr_acl=0
> auth_algs=1
> ignore_broadcast_ssid=0
> ---
>
> The results were similar.
>
> Could anyone, guide me or provide me a simple hostapd.conf file, that
> will help me connect clients. I do not want authentication,
> encryption, and DHCP -- will use static IP.
>
> Thanks in advance.
>
> -shankar
