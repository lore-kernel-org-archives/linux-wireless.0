Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39507 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GSRCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 13:02:10 -0400
Date: Thu, 19 Jul 2012 12:37:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Duan Jiong <djduanjiong@gmail.com>, dcbw@redhat.com,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RESEND] firmware.c: remove duplicated include
Message-ID: <20120719163733.GB1846@tuxdriver.com> (sfid-20120719_190214_485889_50375CA3)
References: <5006CCE7.8090904@gmail.com>
 <87sjco6sn5.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87sjco6sn5.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2012 at 11:51:10AM +0300, Kalle Valo wrote:
> Duan Jiong <djduanjiong@gmail.com> writes:
> 
> > Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
> 
> Please prefix the subject with "libertas:", like this:
> 
> libertas: remove duplicated include in firmware.c

I fixed-up the subject and committed it to wireless-next.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
