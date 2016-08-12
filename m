Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbcHLIQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 04:16:44 -0400
Date: Fri, 12 Aug 2016 10:13:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160812081342.GA15538@redhat.com> (sfid-20160812_102111_209990_28F1A204)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com>
 <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
 <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
 <20160811122917.GB27059@redhat.com>
 <fc70c75bfcab4e0e932274034b5b4493@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fc70c75bfcab4e0e932274034b5b4493@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2016 at 07:17:38AM +0000, Amitkumar Karwar wrote:
> The problem looks strange. The patch just splits mwifiex_check_fw_status() and increases poll count. It should not have any side-effects.
> Our code used to check winner status before this patch also.

Ok, I misread the patch. Anyway checking "winner status" seems
does not work well on some condition and prevent loading firmware
into device.

Stanislaw
