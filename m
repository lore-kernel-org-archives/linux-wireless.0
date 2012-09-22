Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56249 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2IVDah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 23:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <20572.46476.617076.695309@gargle.gargle.HOWL>
References: <20572.46476.617076.695309@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 21 Sep 2012 20:30:16 -0700
Message-ID: <CAB=NE6UgCJKrWvfPbn5f1od5tJ5DU9qYEigRZMHXtsVXy5fukA@mail.gmail.com> (sfid-20120922_053042_589707_19E5F96D)
Subject: Re: [PATCH] ath9k: Disable ASPM only for AR9285
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2012 at 11:44 AM, Sujith Manoharan
<c_manoha@qualcomm.com> wrote:
> Currently, ASPM is disabled for all WLAN+BT combo chipsets
> when BTCOEX is enabled. This is incorrect since the workaround
> is required only for WB195, which is a AR9285+AR3011 combo
> solution. Fix this by checking for the HW version when enabling
> the workaround.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

I've sucked this into the origin/linux-3.5.y branch, and am working on
ckmake test compiling a new stable release that brings up on to
v3.5.4. All changes have been pushed. The new Bluetooth stable patches
from linux-next were plain stupid but I've tried backporting them.

waiting on ckmake result.

  Luis
