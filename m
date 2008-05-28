Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4110 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYE1M6e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 08:58:34 -0400
Date: Tue, 27 May 2008 20:24:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ronald <ronald645@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: error on make
Message-ID: <20080528002402.GE7779@tuxdriver.com> (sfid-20080528_145838_694154_A3F34386)
References: <48381D8F.5010707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48381D8F.5010707@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 03:52:15PM +0200, Ronald wrote:
> Did you remove the wireless patches from the Fedora stock kernel build? I 
> think that could colide......

Very likely...the best bet for Fedora users looking for hot, fresh
code is to go here:

	http://koji.fedoraproject.org/koji/packageinfo?packageID=8

Find the latest kernel for your distro (F8, F9, or Rawhide aka F10)
and generally that will give you something identical or very close
to what is currently in wireless-testing or compat-wireless.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
