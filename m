Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759765Ab0CPRDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 13:03:00 -0400
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
From: reinette chatre <reinette.chatre@intel.com>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 10:00:59 -0700
Message-ID: <1268758859.2446.595.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-14 at 11:44 -0700, Adel Gadllah wrote:
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
> 
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: stable@kernel.org
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


