Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2CLAT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 20:19:28 -0400
Received: by iagz16 with SMTP id z16so6019491iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2012 17:19:27 -0700 (PDT)
Message-ID: <4F5D410D.2030005@lwfinger.net> (sfid-20120312_011932_013830_BB3561A2)
Date: Sun, 11 Mar 2012 19:19:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <17646354.573873.1331505374568.JavaMail.root@vms170029>
In-Reply-To: <17646354.573873.1331505374568.JavaMail.root@vms170029>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2012 05:36 PM, alupu@verizon.net wrote:
> Hi Larry,
>
> A few _quick_ notes ("impressions") so you can get me more/detailed
> instructions while I'm getting the hang of openSUSE :)
>
>> Could you please download a Live KDE CD from
>> software.opensuse.org/121/en
>> It should not matter whether you use the 32- or 64-bit version.
>> After you boot it, use the NetworkManager system tray
>> applet to connect to your system.
>> Does that work?
>
> Yes. How? Very smoothly.
>
>> Next, use 'ps ax' to get the PID for NetworkManager and kill it.
>> Then try your iwconfig/ifconfig command sequence.
>> Does that work?
>
> No. Same old story.
> Actually, I tried the "iwconfig/ifconfig" (from the KDE terminal) first.
> It didn't work so then, quite discouraged, I went to the NM above.
> As I said, worked AOK, I then killed the guy, so I can try
> the "iwconfig/ifconfig" again. No cigar, as I explained above.
>
> Note: in retrospect, I'm wondering if in Knoppix what would've
> happened if I had tried his graphics mode (some sort of KDE clone).
> An even bigger wonder. I'll be looking into that:
> When doing 'ps ...' I noticed there was a wpa_supplicant(?) running.
> If that was a requirement for NM, it should've helped when I went "down"
> in command (KDE terminal) mode as well. ???
> I don't remember if the supplicant process was killed (as a side effect).

I know that the openSUSE Live CD works on my computer with the Rosewill device 
and WEP encryption. That tells me that the driver is working correctly, and that 
the user-space stuff is OK. Let's see if we can find what is wrong for you.

After the Live CD boots, do you see the NM applet in the lower-right hand corner 
of the screen?

When you click on it, do you see a list of APs that are in range?

If you click on yours, do you get a screen that wants to know the WEP key? You 
will need to enter the hexadecimal key, not any passphrase. You will also get a 
popup asking if you want to use kwallet. Say yes and give it a blank password.

Did you get a connection? Note, NM uses wpa_supplicant even for WEP. That is normal.

Larry

