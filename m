Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43443 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161178Ab2KNMVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:21:40 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Jason Baron <jbaron@redhat.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
Date: Wed, 14 Nov 2012 14:21:36 +0200
Message-ID: <3761754.Ygum1MzQtO@lx-vladimir> (sfid-20121114_132143_750335_E37C066B)
In-Reply-To: <20121113134436.de5df090.akpm@linux-foundation.org>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352811970.24230.22.camel@joe-AO722> <20121113134436.de5df090.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, November 13, 2012 01:44:36 PM Andrew Morton wrote:
> Agree that the above should be in a core header file.
> 
> Disagree with placing it in a wireless header.
> 
> Please split it out into a standalone patch.

RFC sent - see for message titled
[RFC] debug_hex_dump()
