Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:37588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbbEIAMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 20:12:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, dhowells@redhat.com,
	ming.lei@canonical.com, seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v1 01/12] kernel/params.c: export param_ops_bool_enable_only
In-Reply-To: <1430873070-7290-2-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com> <1430873070-7290-2-git-send-email-mcgrof@do-not-panic.com>
Date: Sat, 09 May 2015 03:26:11 +0930
Message-ID: <876183lzr8.fsf@rustcorp.com.au> (sfid-20150509_021302_285925_92D5E0DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This will grant access to this helper to code built as modules.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Kyle McMartin <kyle@kernel.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Applied,
Rusty.
