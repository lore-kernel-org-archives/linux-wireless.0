Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61368 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2D3EIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 00:08:43 -0400
Received: by iadi9 with SMTP id i9so3612087iad.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 21:08:42 -0700 (PDT)
Message-ID: <4F9E1047.9030103@lwfinger.net> (sfid-20120430_060847_181996_BBB3E627)
Date: Sun, 29 Apr 2012 23:08:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: simple w8 <simplew8@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
References: <CAKVccoU7CnhVVQ82U23Yuww6VrTMU4FsjWcWVbk16LNKyQfvOQ@mail.gmail.com> <A872091605A443F48DE1814CF6FAFE25@realtek.com.tw> <CAKVccoUfER_m48BtyMjo3pix2_BmqBZ8kxij_RxDhOLEN5Q-9A@mail.gmail.com> <4F9AF76A.4040607@lwfinger.net> <CAKVccoUbcvO-X5w2pOuOyP=DhK+64opsJm5muznjsOWu==MUcQ@mail.gmail.com> <4F9B63CF.4010005@lwfinger.net> <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com> <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com> <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com> <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com> <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com> <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com> <4F9DFF0A.7080604@lwfinger.net> <CAKVccoWt-rhfWBynb2kTXD6CU52WtXfqYNmmOCmUaTqCfjdWzg@mail.gmail.com>
In-Reply-To: <CAKVccoWt-rhfWBynb2kTXD6CU52WtXfqYNmmOCmUaTqCfjdWzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 10:35 PM, simple w8 wrote:
>
> So you also use wpa_supplicant, so what happens is that when i turn
> off wpa_supplicant the problem goes away but i also loose wifi
> internet, and of course if i unload the rtl8192ce module.
>
> This problem has been existing for quite some time, also in another 2
> machines that also have realtek wifi cards, so this problem isnt just
> from this specific card, but i really cant tell if this is really some
> caused by the realtek drivers or wpa_supplicant or any other thing...
>
> I have mailed hostap mailing list to see what were the chances someone
> knows about a similiar problem but the no one seams to know...

Yes, I use wpa_supplicant and I do not have the problem. If you change to an 
unencrypted AP, then wpa_supplicant will not be used. It will be loaded, but not 
used.

what version of wpa_supplicant are you using? Mine is 0.7.3.

Larry



