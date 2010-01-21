Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42781 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0AUSAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:00:37 -0500
Date: Thu, 21 Jan 2010 12:59:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] libertas: Set/clear WPA keys before the WEP ones
Message-ID: <20100121175920.GB2921@tuxdriver.com>
References: <20100118231920.GH5176@sortiz.org> <20100121172618.GA17610@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100121172618.GA17610@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 06:26:19PM +0100, Samuel Ortiz wrote:
> 
> With the v10 firmware running on 8688 HW, clearing WPA keys after setting the
> WEP key prevents us from being able to associate with WEP APs.
> Swapping the calling order for assoc_helper_wpa_keys() and
> assoc_helper_wep_keys() fixes that issue.
> 
> Acked-by: Dan Williams <dcbw@redhat.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

I already applied the first version of the patch.  Could you send
one w/ just the new changes?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
