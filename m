Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45024 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1JHX35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 19:29:57 -0400
Received: by qadb15 with SMTP id b15so3357146qad.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 16:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E907FB8.1040101@lwfinger.net>
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com>
 <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com>
 <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net>
 <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net>
 <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net>
 <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net>
 <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com>
 <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org>
 <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org>
 <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net>
 <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 9 Oct 2011 01:29:34 +0200
Message-ID: <CA+XFjio+on2rUymoSZNxOWKMX9xOn5hutA6q01r0yBeOXz0ivw@mail.gmail.com> (sfid-20111009_013011_690198_3C9FC00E)
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Toddy <toddy@fishpost.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 8, 2011 at 6:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 10/08/2011 11:24 AM, Toddy wrote:
>>
>> Hello Larry,
>>
>> thanks for the quick reply! Yes I know this version is a bit older, but
>> when I
>> use the newest compat-wireless (eg.
>>
>> http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2011-10-07.tar.bz2)
>> the driver loads but some features like monitor-mode and packet injection
>> doesn't work. The listing of available networks (with airodump) doesn't
>> work
>> too. Usually I have 13 channels because I live in Germany but if I use the
>> newest driver I have only 11 channels. But if I use the older
>> compat-wireless
>> package all works fine.
>
> The difference between 11 and 13 channels depends on your CRDA settings. Do
> you have that package installed? Check the output of dmesg to see what
> domain is being set. If you have CRDA installed, then you can force the use
> of Germany in the domain by creating a file named
> /etc/modprobe.d/50-cfg80211.conf containing a single line with "options
> cfg80211 ieee80211_regdom=DE" (without the quote marks).
>
> You can get a list of available networks using iwconfig or iw. I know those
> work.
>
> As I do not test, support, nor condone packet injection, I cannot speak to
> it working on any driver.

Well, packet injection is required for Hostapd to work.

>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
