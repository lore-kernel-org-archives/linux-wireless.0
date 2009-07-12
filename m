Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23034 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbZGLO5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 10:57:30 -0400
Message-ID: <20090712105807.g85wo8lpgk04k8gk-cebfxv@webmail.spamcop.net>
Date: Sun, 12 Jul 2009 10:58:07 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: orinoco-devel@lists.sourceforge.net,
	David Gerard <dgerard@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] orinoco-usb in 2.6.31?
References: <fbad4e140907081555w3a98c570y54d904272094008@mail.gmail.com>
	<4A577DA9.9000205@gmail.com> <4A57DC26.4090708@gmail.com>
	<4A58FC5C.8060204@gmail.com>
In-Reply-To: <4A58FC5C.8060204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dave <kilroyd@googlemail.com>:

> The rebasing was a little painful due to all the changes that have been
> happening on orinoco. However I think I'm done.

I have an impression that orinoco-usb should be submitted to the  
staging tree.  Perhaps its symbols should be renamed to allow it to  
coexist with the plain orinoco driver, even if both are linked into  
the kernel.

I was hoping that we would reorganize the orinoco driver to allow  
orinoco-usb to be one of its frontends, but it's not happening.  All  
the efforts that go into orinoco-usb is keeping it up-to-date with the  
kernel.

-- 
Regards,
Pavel Roskin
