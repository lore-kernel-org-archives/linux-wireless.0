Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab2BCPgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 10:36:01 -0500
Date: Fri, 3 Feb 2012 16:35:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/25] iwlegacy update 2012-02-03
Message-ID: <20120203153542.GC2213@redhat.com> (sfid-20120203_163605_692690_5F1A7DA2)
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 03, 2012 at 01:07:00PM +0100, Stanislaw Gruszka wrote:
> This patch set include various cleanups, mostly patches intended to
> remove unused "ctx" structure.

John, please drop this set, except problem pointed by Gertjan, it also
breaks compilation with CONFIG_IWLEGACY_DEBUGFS=y. I'll repost fixed
set shortly.

Stanislaw
