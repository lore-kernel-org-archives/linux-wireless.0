Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55290 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993251Ab2KOLxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 06:53:02 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8 4/4] dynamic_debug: dynamic hex dump
Date: Thu, 15 Nov 2012 13:52:58 +0200
Message-ID: <3592518.VuNh0OxpcK@lx-vladimir> (sfid-20121115_125307_452064_44D89488)
In-Reply-To: <1352978222-13866-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352978222-13866-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, November 15, 2012 01:17:02 PM Vladimir Kondratiev wrote:
> Introduce print_hex_dump_debug() that can be dynamically controlled, similar
> to pr_debug.

To clarify: this patch is here for completeness only; discussion about it 
moved to lkml. I expect it to be merged; then it will come from main tree.
