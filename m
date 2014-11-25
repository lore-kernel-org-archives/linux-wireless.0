Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48705 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaKYTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:00:14 -0500
Date: Tue, 25 Nov 2014 13:51:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] brcmutil: add helper function to format board
 revision
Message-ID: <20141125185120.GF15476@tuxdriver.com> (sfid-20141125_200020_254265_57C3E1CC)
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
 <1416518822-29585-3-git-send-email-arend@broadcom.com>
 <20141124215352.GB4484@tuxdriver.com>
 <5474538B.70207@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5474538B.70207@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 11:01:47AM +0100, Arend van Spriel wrote:
> On 11/24/14 22:53, John W. Linville wrote:
> >I am holding patches 2-4 until we resolve the brcmu_boardrev_str
> >build thing...
> 
> Actually, only patch 2 and 3 are related to the build thing. If that is what
> this is.
 
OK, I won't hold-up #4...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
