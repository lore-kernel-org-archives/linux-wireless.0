Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54410 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2FGLqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 07:46:44 -0400
Received: by dady13 with SMTP id y13so763001dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 04:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120607T130146-946@post.gmane.org>
References: <loom.20120607T100950-564@post.gmane.org>
	<CAJwzM1mTyOv6cUjTQ00-Q-5aW872kwyBPgnH9Pnk82fLZ+-J2w@mail.gmail.com>
	<loom.20120607T121239-785@post.gmane.org>
	<CAJwzM1n2-K+J5ado9fUVBNuOumAfp0R0kwHj6jFSuOFJHap61Q@mail.gmail.com>
	<loom.20120607T130146-946@post.gmane.org>
Date: Thu, 7 Jun 2012 17:16:43 +0530
Message-ID: <CAJwzM1n5+9KiK0g6psQfsNf3_Ea1YF3d11ZiFDTv0awdhyAddA@mail.gmail.com> (sfid-20120607_134648_500554_F522187A)
Subject: Re: mwifiex:Testing AP functionality with hostapd
From: Avinash Patil <avinashapatil@gmail.com>
To: =?ISO-8859-1?Q?Hans_Kr=F6ner?= <hanskroner@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Hans,
My libnl version libnl-1.

Also there are no changes in .config. Simply copy defconfig to .config.

Regards,
Avinash

On Thu, Jun 7, 2012 at 4:34 PM, Hans Kröner <hanskroner@gmail.com> wrote:
> Hi Avinash,
>
> I'll try to build that version in a little while. At the time of that revision,
> hostapd could not be linked against libnl-3. When you built the version you
> tested against, were you using libnl-1 or libnl-2?
>
> Could you provide me with the .config file you used to build hostapd so I can
> be sure that I'm not including things I shouldn't be, or missing important
> parts?
>
> Thanks again!
>
> Best Regards,
>
> Hans
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
