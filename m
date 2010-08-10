Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53228 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab0HJREt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 13:04:49 -0400
Subject: Re: [ipw3945-devel] [PATCH 0/1] fix for 2.6.35
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTinJtJGQCgpWCu5t+EF7bEvXR3cQG7oHuagrjd1a@mail.gmail.com>
References: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
	 <AANLkTinJtJGQCgpWCu5t+EF7bEvXR3cQG7oHuagrjd1a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Aug 2010 10:04:32 -0700
Message-Id: <1281459872.6027.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Tue, 2010-08-10 at 09:51 -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 9, 2010 at 10:57 AM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > This patch required for 2.6.35 to fix 5GHz association problem. Without this,
> > iwlagn device will have issue connecting to 11a AP
> >
> > Johannes Berg (1):
> >  iwlagn: fix rts cts protection
> 
> This patch has an awesome commit log entry and describes issues with
> the current RTS mechanism and improvements made on the patch for
> different scenarios but in no way talks about issues with association
> with 5 GHz APs. Can you clarify in the commit log how it cures issues
> with 5 GHz, if that is indeed an intended fix for it?
> 

Johannes might be able to add more, the original attempt of this patch
is to prevent un-necessary protection for non-data frames which we
introduced few rc ago. while we fix this, but we also found out this
patch also address the issue we have for 5GHz unable to associate to AP.

Thanks
Wey

