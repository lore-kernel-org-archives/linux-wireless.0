Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:63653 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbXCKMu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 08:50:58 -0400
Date: Sun, 11 Mar 2007 13:50:56 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] zd1211rw: sparse-annotate radiotap header
Message-ID: <20070311125056.GA14635@p15091797.pureserver.info>
References: <20070311044016.1351.41028.stgit@dv.roinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070311044016.1351.41028.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-03-10 23:40 Pavel Roskin wrote:

> All fields in radiotap header must be little endian.  The driver does it
> correctly, but the structure definition must be annotated.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Ulrich Kunitz <kune@deine-taler.de>

I have put the patch in the zd1211rw branch of my wireless-dev
git tree, which can be found under

http://www.deine-taler.de/zd1211/wireless-dev.git/

Cheers,

Uli

-- 
Uli Kunitz
