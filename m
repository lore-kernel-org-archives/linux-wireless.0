Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0KJPzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 10:55:20 -0500
Subject: Re: [PATCH v7] iw: Add antenna configuration commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101110035122.23770.72735.stgit@localhost6.localdomain6>
References: <20101110035122.23770.72735.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 07:56:39 -0800
Message-ID: <1289404599.3748.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 12:51 +0900, Bruno Randolf wrote:

> +COMMAND(set, antenna, "<bitmap> | all | tx <bitmap> rx <bitmap>",

I think the parser is too complicated, how about

"all | <bitmap> | <tx bitmap> <rx bitmap>

johannes

