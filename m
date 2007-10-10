Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2067 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXJJTJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 15:09:07 -0400
Date: Wed, 10 Oct 2007 14:32:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, proski@gnu.org,
	hermes@gibson.dropbear.id.au
Subject: Re: [RFC PATCH] orinoco: more reliable scan handling
Message-ID: <20071010183251.GK5962@tuxdriver.com> (sfid-20071010_200913_385104_DC353DE3)
References: <1191946643.20183.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191946643.20183.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 09, 2007 at 12:17:23PM -0400, Dan Williams wrote:
> Bring scan result handling more in line with drivers like ipw.  Scan
> results are aggregated and a BSS dropped after 15 seconds if no beacon
> is received.  This allows the driver to interact better with userspace
> where more than one process may request scans or results at any time.

Are there some orinoco.h changes?  This patch seems to refer to
orinoco_private fields that don't exist...?

John
-- 
John W. Linville
linville@tuxdriver.com
