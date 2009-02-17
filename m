Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f167.google.com ([209.85.218.167]:44993 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZBQANI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 19:13:08 -0500
Received: by bwz11 with SMTP id 11so1725090bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 16:13:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ec5eb5d60902160333k52bfcb5bj4122be2f853f0590@mail.gmail.com>
References: <6ad5d99d0902091343v693173f2w61ff60a216bb15e9@mail.gmail.com>
	 <4990AC02.6030703@lwfinger.net>
	 <3ace41890902091433g4c4e0c17n9e01aabc613d5bb6@mail.gmail.com>
	 <6ad5d99d0902111412m97608eanf6c2fd3e8bc6af4c@mail.gmail.com>
	 <3ace41890902111445k606682a8p197a9eb65cdbc3a2@mail.gmail.com>
	 <ec5eb5d60902160333k52bfcb5bj4122be2f853f0590@mail.gmail.com>
Date: Tue, 17 Feb 2009 00:13:04 +0000
Message-ID: <3ace41890902161613o16586a95o2683f1976d7456fe@mail.gmail.com> (sfid-20090217_011311_958893_83EA11E2)
Subject: Re: rtl8187 in Toshiba L300 linux troubles
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Jorge_Mu=F1oz?= <jorgeroden@gmail.com>
Cc: Jorge Munoz <jorgeroden1@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 11:33 AM, Jorge Mu=F1oz <jorgeroden@gmail.com> =
wrote:
> Thanks Hin-Tak, I haven't checked your answer yet. When I have got an
> answer I' ll post here. But I have to say that I' ve compiled (Ubuntu
> 8.10 distro based) compat-wireless without uninstalling
> linux-backports-modules-2.6.27-11-generic and rtl8187 works correctly=
=2E
>
> In order to installing compat-wireless rtl8187 driver I' ve done a
> shell script to automate compilation process but next
> step should be create a .deb package to include this in a repository
> tree. Do you know if is there one with stable rtl8187 driver yet
> (2.6.27-11)?
>

If you just want to distribute your build of kernel modules, you could
just tar up
/lib/modules/*/updates from your machine and untar that on the target m=
achine.

As I said, kernel modules are kernel-version specific, so I am afraid
for each kernel you want to boot you need to build a deb package, if
that's your direction. Something like dkms or equivalent may help you.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
