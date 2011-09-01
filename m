Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f45.google.com ([209.85.216.45]:48046 "EHLO
	mail-qw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab1IAQls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 12:41:48 -0400
Received: by qwj8 with SMTP id 8so1457787qwj.4
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 09:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110901155411.4399.39055.stgit@mj>
References: <20110901155411.4399.39055.stgit@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 1 Sep 2011 09:41:28 -0700
Message-ID: <CAB=NE6UfZ0+-yHc_8GjSDGdvRuQvmAPXKw7V=X9_JTv++VRhGQ@mail.gmail.com> (sfid-20110901_184152_101092_0D962E49)
Subject: Re: [PATCH] cfg80211: print bandwidth in chan_reg_rule_print_dbg()
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 1, 2011 at 8:54 AM, Pavel Roskin <proski@gnu.org> wrote:
> Two spaces and the second "KHz" suggest that the code author meant to
> print the bandwidth but forgot it.  The code appears in commit e702d3cf
> already with two spaces and "KHz" in place of the bandwidth.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
