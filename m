Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64931 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab2GLOrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:47:49 -0400
Received: by yhmm54 with SMTP id m54so2775028yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 07:47:48 -0700 (PDT)
Message-ID: <4FFEE390.8080104@lwfinger.net> (sfid-20120712_164800_382934_6FBB8E8F)
Date: Thu, 12 Jul 2012 09:47:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem with installing the kernel
References: <loom.20120712T044726-224@post.gmane.org> <4FFE437E.8080008@lwfinger.net> <loom.20120712T060947-580@post.gmane.org>
In-Reply-To: <loom.20120712T060947-580@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 11:13 PM, Ouyang wrote:
>
> Thank you so much for the reply. Sorry that I run "make" as a root. I am new
> with linux and I am sure I won`t make the same mistake in the future. By the way
> , why it tells me about try "rm -- help"? I really do not know what does it
> mean. In what situation will this "rm -- help " come out?

In some script that is called from "make modules_install", your system is 
calling the utility rm with option 3. That is not a standard script. It could be 
that something is messed up with your source tree. If you reload the source that 
you got from Fedora, and rebuild as a regular user, it might fix the problem. If 
not, you need to ask on a Fedora forum. The wireless and mainline kernels do not 
have this problem.

Larry

