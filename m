Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60514 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J3Vqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:46:44 -0400
Received: by mail-lb0-f169.google.com with SMTP id o14so1757290lbi.28
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 30 Oct 2013 22:46:23 +0100
Message-ID: <CAB=NE6W7xpp_zr7a_Dtkbiqe9fo5=Si_GjkAr1wypSPgng64rw@mail.gmail.com> (sfid-20131030_224931_532170_387A7872)
Subject: Re: [PATCH 0/7] wireless-regdb: DFS regions and optimizations
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 30, 2013 at 10:45 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> This patch series associates a slew of countries
> to DFS regions and then provides updates to 4
> countries based on the new CRDA optimizer. The
> optimizations have no functional changes other
> than reducing the size of the regulatory domain
> data strucutre that would be used to send to
> the kernel.

I should note that this depends on the removal of antenna gain patch.

  Luis
