Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58468 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3CDPPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:15:25 -0500
Date: Mon, 4 Mar 2013 10:11:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: is L1 really disabled in iwlwifi
Message-ID: <20130304151133.GD23686@tuxdriver.com> (sfid-20130304_161528_740734_CA8F0638)
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com>
 <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 04:57:46PM +0200, Emmanuel Grumbach wrote:

> Right, good point. The thing is that the device doesn't know how to do
> both L0S and L1. This is the origin of this code. But obviously, we
> first need to make sure that L0S is supported in the LnkCtl. Will
> check.
> Thanks!
> 
> So - what about just removing this code?

As long as the device doesn't randoly disconnect itself from the bus...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
