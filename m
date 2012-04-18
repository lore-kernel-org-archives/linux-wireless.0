Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54029 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DRS0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 14:26:55 -0400
Received: by bkcik5 with SMTP id ik5so5739023bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 11:26:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: carl9170 firmware
Date: Wed, 18 Apr 2012 20:26:49 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4F8DA785.6040608@lwfinger.net> <201204172035.06023.chunkeey@googlemail.com> <4F8DC439.103@lwfinger.net>
In-Reply-To: <4F8DC439.103@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204182026.49607.chunkeey@googlemail.com> (sfid-20120418_202659_281438_6AA5E1CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 17, 2012 09:27:53 PM Larry Finger wrote:
> On 04/17/2012 01:35 PM, Christian Lamparter wrote:
> > On Tuesday, April 17, 2012 07:25:25 PM Larry Finger wrote:
> >> A question regarding adding carl9170-1.fw to the openSUSE firmware package is
> >> being discussed on the oS kernel mailing list; however, I do not see that one
> >> in the linux-firmware git repo. Should it be there?
> > Does the repo take source code releases? [much like the work we do for the
> > kernel driver, or have you ever seen a binary release on this ML :D ]. The
> > files on<http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary>
> > are just for convenience.
> 
> AFAIK, the repo only takes binary files. With the source under GPL2, that should 
> not be a problem; however, the fact that there are two versions with the same 
> name would be trouble. Adding under that name has the possibility of breaking 
> all the systems that use the other version.
I think I would need to read the opensuse ML discussion first to know why this
is a "big" deal suddenly. (do you have a link?)

On the other hand: I don't like the idea of supporting "old" & "new" firmwares.
Usually they get mixed up and then you end up with "new" reports for
"old" bugs. In fact, p54 users' complain about that alot.

Regards,
	Chr
