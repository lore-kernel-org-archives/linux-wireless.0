Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42176 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935048Ab1KJPPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:15:19 -0500
Date: Thu, 10 Nov 2011 10:01:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: New wireless-testing has grown some warnings -- please fix ASAP!
Message-ID: <20111110150119.GA3445@tuxdriver.com> (sfid-20111110_161526_679162_33A47C8B)
References: <20111109215007.GD10712@tuxdriver.com>
 <4EBB1392.20105@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EBB1392.20105@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 09, 2011 at 05:58:10PM -0600, Larry Finger wrote:
> On 11/09/2011 03:50 PM, John W. Linville wrote:
> >commit befdbc51cc69c01cd412ad2429960b9c3042f97c is the current
> >wireless-testing head.
> >
> >This iteration of wireless-testing seems to have grown some
> >warnings.  Some of them come from a new __must_check annotation of
> >cfg80211_inform_bss, while others are simply unused or uninitialized
> >variables.  In any case, I would prefer not to see them.
> >
> >Please check the wireless-testing build and attempt to squash any
> >warnings that can be reasonably squashed.  Those who do not do so
> >will be subject to irritated sighs over IRC, drunken emails about
> >my new DVD rental service, and accusations of making unwanted sexual
> >advances toward me.  You've been warned.
> >
> >John
> 
> For the record, what compiler are you using?

[linville-8530p.local]:> gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared
--enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile
--enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
