Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34697 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab0KNMW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 07:22:58 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PHbbj-0005hH-1u
	for linux-wireless@vger.kernel.org; Sun, 14 Nov 2010 13:22:55 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 13:22:55 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 13:22:55 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Sun, 14 Nov 2010 12:22:16 +0000
Message-ID: <ibokag$481$1@dough.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <4CDEEEE4.80801@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/11/10 20:02, Larry Finger wrote:
> On 11/13/2010 01:27 PM, James Womack wrote:
>> If building a kernel is as simple as building other programs from source
>> (i.e. configure, make, make install), I could do that. I'm using Debian
>> at the moment. Presumably I'd need a compiler of some kind, which I
>> could obtain from the repos. I am not sure how one would apply patches
>> to the kernel, however. Would I be able to compile a modified kernel and
>> add this to grub whilst retaining the ability to boot in the unmodified
>> kernel?
>
> It is similar to the process used with other programs. My distro is openSUSE and
> the steps are to get the kernel source, the kernel development package, and the
> patch utility using YaST. Other distros use emerge, apt-get, or similar
> utilities. The easiest way to configure the kernel is to match the current one
> using the compressed version in /proc/config.gz. You should end up with an
> additional kernel in the GRUB menu that can be selected at boot time.
>
> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Okay, I've downloaded the necessary tools and extracted the kernel 
source. I have a tutorial on how to patch and build the kernel. Where 
should I apply your patches?

James

