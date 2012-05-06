Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44177 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2EFRqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 13:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120506.123656.1335354317428258137.davem@davemloft.net>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
	<20120506.123656.1335354317428258137.davem@davemloft.net>
Date: Sun, 6 May 2012 19:46:46 +0200
Message-ID: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com> (sfid-20120506_194717_255585_60A4BB97)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Herrmann <dh.herrmann@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David

On Sun, May 6, 2012 at 6:36 PM, David Miller <davem@davemloft.net> wrote:
> From: Gustavo Padovan <gustavo@padovan.org>
> Date: Fri,  4 May 2012 15:59:48 -0300
>
>> Fix offending styles all over the tree. This is in conformance David
>> Miller's style rules.
>
> They aren't just my style rules.

Whose rules are they?

Reading ./Documentation/CodingStyle I see:
+++++++
Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation, and the above example is deliberately broken.
+++++++

Or looking at the last 3 of Linus' commits that use multi-line
expressions, none of them uses mixed tabs+spaces to have lined-up
indentation (which is what you recommend):

e419b4cc585680940bc42f8ca8a071d6023fb1bb vfs: make word-at-a-time...
6be5ceb02e98eaf6cfc4f8b12a896d04023f340d VM: Add "vm_mmap" helper...
a554bea89948dfb6d2f9c4c62ce2b12b2dac18ad selinux: don't inline...

So why so reluctant to calling it "David's style"?

> And, if your plan is to patch things up afterwards so you don't
> have to change existing commits in your tree, think again.
>
> I absolutely will not pull a tree from John that has commits in
> it that add the bad indentation.
>
> You have to respin your tree with fixed commits.

That's just old code that is reindented. Nothing special. All new
commits use the new coding-style properly.

> The bluetooth folks have to understand that they are on an extremely
> short leash right now.

Regards
David
