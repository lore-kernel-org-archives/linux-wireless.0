Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4351 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXLTPAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 10:00:09 -0500
Date: Thu, 20 Dec 2007 09:34:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arnd Bergmann <arndb@de.ibm.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/8] debugfs: allow access to signed values
Message-ID: <20071220143418.GD3139@tuxdriver.com> (sfid-20071220_150015_632536_66B2BE7C)
References: <20071219001955.055692620@polimi.it> <20071219012739.6dcdd150@morte> <1198080034.4747.15.camel@johannes.berg> <20071220134022.43f39072@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071220134022.43f39072@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2007 at 01:40:22PM +0100, Stefano Brivio wrote:
> debugfs: allow access to signed values
> 
> Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
> a cast in libfs, change the simple_attr_open prototype and thus fix the users as
> well.

Looks like Stefano is going to cooperate w/ hch on this, so I'm
dropping this from wireless-2.6 for now...FYI

John
-- 
John W. Linville
linville@tuxdriver.com
