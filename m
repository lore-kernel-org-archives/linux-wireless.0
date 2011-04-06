Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1DFOYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:24:14 -0400
Date: Wed, 6 Apr 2011 16:18:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] iwlwifi: fix enqueue hcmd race conditions
Message-ID: <20110406141848.GA8979@redhat.com>
References: <1301585788-7331-1-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501428BA47D@orsmsx506.amr.corp.intel.com>
 <20110401072206.GA2790@redhat.com>
 <1301670445.22383.11.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301670445.22383.11.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 01, 2011 at 08:07:25AM -0700, wwguy wrote:
> > > Do you have a bug# against this?
> > No, I was fixing problems happened on my local system.
> > 
> fair enough :-), thanks for the update

So we could consider patch as acked.

Stanislaw
