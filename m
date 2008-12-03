Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:9297 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYLCAUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 19:20:34 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1342661yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 16:20:32 -0800 (PST)
Message-ID: <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com> (sfid-20081203_012043_453108_4133D5F0)
Date: Tue, 2 Dec 2008 16:20:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX gracefully
Cc: stable@kernel.org, sfr@canb.auug.org.au,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <20081203001253.GC14943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-3-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-4-git-send-email-lrodriguez@atheros.com>
	 <20081203001253.GC14943@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
> I don't see this patch upstream in Linus's tree.  Am I just missing it
> and if so, do you know the git commit id?

Nope sorry, John has yet to send his pending-fixes branch to davem and
so forth, which would contain it AFAICT. Please correct me if I'm
wrong John.

  Luis
