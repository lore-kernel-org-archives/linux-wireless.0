Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc2s35.hotmail.com ([65.55.111.110]:55535 "EHLO
	BLU004-OMC2S35.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbaJPSsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 14:48:18 -0400
Message-ID: <BLU436-SMTP1559977BA6EA46847DBB713C3AB0@phx.gbl> (sfid-20141016_204822_621118_CE233FF3)
Date: Thu, 16 Oct 2014 20:48:13 +0200
From: Sir l33tname <l33tname@outlook.com>
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: r8723au module
References: <BLU437-SMTP3548C40225183D5FB08040C3AC0@phx.gbl> <wrfjlhojktqa.fsf@redhat.com>
In-Reply-To: <wrfjlhojktqa.fsf@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

# wl -i eth1 status
SSID: "janus"
Mode: Managed	RSSI: 0 dBm	SNR: 0 dB	noise: -90 dBm	Channel: 8l
BSSID: 2C:B0:5D:XX:XD:XX	Capability: ESS ShortSlot
Supported Rates: [ 1(b) 2(b) 5.5(b) 6 9 11(b) 12 18 24 36 48 54 ]
802.11N Capable:
	Chanspec: 2.4GHz channel 10 40MHz (0x2d0a)
	Control channel: 8
	802.11N Capabilities:
	Supported MCS : [ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 32 ]

Security is WPA / WPA2 Personal with AES encription.

But I don't think that is has anything to do with my AP because other
people seems to have the same problem. One of them claimed that it work
better with 'iwconfig <device> freq 2.4G'.

yours sincerely

l33tname


On 10/14/2014 09:15 AM, Jes Sorensen wrote:
> Sir l33tname <l33tname@outlook.com> writes:
>> Hey,
>>
>>
>> Since r8723au is out I have tried it with every kernel version.
>> But every time the connection is flaky, it works fine in the beginning
>> but after ~2 - 5 minutes it stops routing packages get slow, but
>> it shows all the time connected (on my wlan widget). With 8723au build
>> from github, none of this problems exist. (Probably because I build
>> with out Bluetooth?)
>>
>>
>> Output of modinfo
>> https://gist.github.com/fliiiix/f32d8be6c7759e318088
>>
>> Since I have no idea what you need to debug this, please just
>> ask for what I should try or what output do you like to see.
> 
> Hi,
> 
> Can you provide some information about the wireless access point you are
> connected to? Speeds, crypto used, etc.
> 
> Jes
