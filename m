Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0CPO5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 10:57:08 -0400
Date: Tue, 16 Mar 2010 15:55:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
Message-ID: <20100316145507.GA2364@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adel 

On Sun, Mar 14, 2010 at 07:44:59PM +0100, Adel Gadllah wrote:
> From 83bf3f1dba41e3dccdef4fecfccb094559568342 Mon Sep 17 00:00:00 2001
> From: Adel Gadllah <adel.gadllah@gmail.com>
> Date: Sun, 14 Mar 2010 19:16:25 +0100
> Subject: [PATCH] iwlwifi: Silence tfds_in_queue message
> 
> Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
> noisy message, that fills up the log very fast.
> 
> The error seems not to be fatal (the connection is stable and
> performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.

Did you fill a bug report on http://bugzilla.intellinuxwireless.org/
to allow Intel fix the real root of the issue. If not please do.
You may CC me to bug report. 

In general patch looks good for me. 

Cheers
Stanislaw
