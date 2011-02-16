Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57825 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1BPQAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 11:00:35 -0500
Date: Wed, 16 Feb 2011 10:50:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com
Subject: Re: [PATCH 0/5] iwlwifi: Auto-tune tx queue size to maintain latency
 under load
Message-ID: <20110216155011.GC10287@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 13, 2011 at 09:56:37AM -0800, Nathaniel J. Smith wrote:

> This patch series teaches the driver to measure the average rate of
> packet transmission for each tx queue, and adjusts the queue size
> dynamically in an attempt to achieve ~2 ms of added latency.

How did you pick this number?  Is there research to support this as
the correct target for link latency?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
