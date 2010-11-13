Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34983 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0KMUCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 15:02:51 -0500
Received: by yxn35 with SMTP id 35so588497yxn.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 12:02:50 -0800 (PST)
Message-ID: <4CDEEEE4.80801@lwfinger.net>
Date: Sat, 13 Nov 2010 14:02:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Womack <james.c.womack@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org>
In-Reply-To: <ibmosc$4au$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2010 01:27 PM, James Womack wrote:
> If building a kernel is as simple as building other programs from source
> (i.e. configure, make, make install), I could do that. I'm using Debian
> at the moment. Presumably I'd need a compiler of some kind, which I
> could obtain from the repos. I am not sure how one would apply patches
> to the kernel, however. Would I be able to compile a modified kernel and
> add this to grub whilst retaining the ability to boot in the unmodified
> kernel?

It is similar to the process used with other programs. My distro is openSUSE and
the steps are to get the kernel source, the kernel development package, and the
patch utility using YaST. Other distros use emerge, apt-get, or similar
utilities. The easiest way to configure the kernel is to match the current one
using the compressed version in /proc/config.gz. You should end up with an
additional kernel in the GRUB menu that can be selected at boot time.

Larry


