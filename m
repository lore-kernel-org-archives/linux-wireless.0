Return-path: <wireless-bounces@tuxdriver.com>
Received: from pentafluge.infradead.org (pentafluge.infradead.org
	[213.146.154.40])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VEeSLg032539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 09:40:59 -0500
Date: Wed, 31 Jan 2007 14:40:27 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH 2/3] wireless: move wext to net/wireless/
Message-ID: <20070131144027.GA9579@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131013840.GB28076@tuxdriver.com>
	<20070131013943.GC28076@tuxdriver.com>
Mime-Version: 1.0
In-Reply-To: <20070131013943.GC28076@tuxdriver.com>
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On Tue, Jan 30, 2007 at 08:39:43PM -0500, John W. Linville wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch moves net/core/wireless.c to net/wireless/wext.c. I
> refrained from further cleanups though I was tempted. Hence this
> is a pure file move plus various build system adjustments.

Is this the right name?  Shouldn't it be wext-ioctl.c given that
we'll hopefull soon grow a wext implementation with a proper method
table interface for drivers.

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
