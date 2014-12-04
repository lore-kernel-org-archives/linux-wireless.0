Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8.mo5.mail-out.ovh.net ([178.32.116.78]:56637 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712AbaLDKyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 05:54:04 -0500
Received: from mail616.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo5.mail-out.ovh.net (Postfix) with SMTP id A7F25FF9E3E
	for <linux-wireless@vger.kernel.org>; Thu,  4 Dec 2014 09:28:54 +0100 (CET)
Message-ID: <54801B1D.2090209@ventoso.org> (sfid-20141204_115408_848989_AEF51EC5)
Date: Thu, 04 Dec 2014 09:28:13 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Parth Sane <laerdevstudios@gmail.com>
CC: linux-wireless@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com> <CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com> <20141129191601.GA1234@kroah.com> <CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com> <20141130184615.GA3122@kroah.com> <CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com> <20141204012407.GA31191@kroah.com>
In-Reply-To: <20141204012407.GA31191@kroah.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 04/12/14 a les 02:24, Greg Kroah-Hartman ha escrit:
> On Sun, Nov 30, 2014 at 06:55:12PM +0000, Parth Sane wrote:
>> Hi Greg,
>> You can find the source code attached as a tarball. It works and I have tested
>> it myself. You only need to use make and make install for this.
> 
> This really looks like a variant of some existing devices, the rt2x00,
> Ralink driver.

FWIW, if this is the mediatek supplied driver (was this
http://www.spinics.net/lists/linux-driver-devel/msg57929.html the
original message?), it has been discussed here before. It works (when
patched[*]) but (IMHO) it's not suitable for kernel inclusion.

[*] I collected those patches plus a couple I made to make it work with
big endian architecture here:

https://code.google.com/p/mt7601-openwrt/source/browse/#hg%2Fpatches

Bye
-- 
Luca
