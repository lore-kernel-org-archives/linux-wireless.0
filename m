Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbcCRLYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 07:24:30 -0400
Date: Fri, 18 Mar 2016 12:22:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH MOREWORK 17/19] iwl4965: Fix a memory leak in error
 handling code of __il4965_up
Message-ID: <20160318112212.GF24990@redhat.com> (sfid-20160318_122434_065714_30BE8529)
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <3aaac3629455d27b0e9c56ef1615b89873b1b8cf.1458262312.git.julian.calaby@gmail.com>
 <20160318104846.GD24990@redhat.com>
 <CAGRGNgVh+-UOMVmo98HMashUi3CejdXTx4S=sTxq8VcNNrWeag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgVh+-UOMVmo98HMashUi3CejdXTx4S=sTxq8VcNNrWeag@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 10:12:34PM +1100, Julian Calaby wrote:
> I don't think you're right. Looking closely at the code,
> il->num_stations gets incremented in il_prep_station() which is called
> unconditionally from il4965_alloc_bcast_station().
> 
> So I think this and the following patch are fine.

You have right.

Thanks
Stanislaw

