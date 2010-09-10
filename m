Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0IJFlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 01:41:07 -0400
Date: Fri, 10 Sep 2010 07:36:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
Message-ID: <20100910053607.GC2398@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
 <20100909155522.GA376@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDCC3@orsmsx506.amr.corp.intel.com>
 <20100909160646.GB376@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDD02@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDD02@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 09:09:43AM -0700, Guy, Wey-Yi W wrote:
> Understand, I was thinking adding the bug# to the key patch(es) which address the problem such as #4, #6, ...etc

Actually most patches, maybe except 3, fix some aspect of problem.
I'll put reference to bug report in 3 or 4 most important patches.

Stanislaw
