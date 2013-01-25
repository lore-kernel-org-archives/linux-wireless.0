Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59355 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3AYVGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 16:06:43 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so421825eei.31
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 13:06:42 -0800 (PST)
Message-ID: <5102F3DF.3040606@gmail.com> (sfid-20130125_220648_096698_24F18A4C)
Date: Fri, 25 Jan 2013 22:06:39 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: balbi@ti.com, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcm WARN() on v3.7.2
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felipe Balbi wrote:

> I'm running Fedora 18 with v3.7.2 on her MacBookAir 11" and it turns out
> that brcm is acting out, see below full dmesg. Any tips ? Is this fixed
> already ?

try kernel-3.7.4-204.fc18: http://koji.fedoraproject.org/koji/buildinfo?buildID=380267


* Wed Jan 23 2013 Justin M. Forbes <jforbes@redhat.com> - 3.7.4-204
- brcmsmac fixes from upstream (rhbz 892428)


# yum update --enablerepo=updates-testing kernel
