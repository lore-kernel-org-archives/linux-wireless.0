Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab2B0TAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 14:00:13 -0500
Subject: Re: [PATCH -iwlwifi] iwlwifi: make tx_cmd_pool kmem cache global
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CANUX_P2Xia4HgF_ooUCTRN0+EqX8dx9Wc1rFiDbiNBdgzu9k5Q@mail.gmail.com>
References: <1330350725-5815-1-git-send-email-sgruszka@redhat.com>
	 <1330353016.12612.13.camel@wwguy-huron>
	 <CANUX_P2Xia4HgF_ooUCTRN0+EqX8dx9Wc1rFiDbiNBdgzu9k5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 09:48:48 -0800
Message-ID: <1330364928.12612.15.camel@wwguy-huron> (sfid-20120227_200018_056618_1CF27119)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 19:55 +0200, Emmanuel Grumbach wrote:
> I guess that Sanislaw patch is defining one single pool for all the
> devices, which means that we won't try to allocate a few pools with
> the same name, which leads to this warning.
> 
That I got it, but is really the "only" way to do it, I am really not a
fan of global variable.

Wey



