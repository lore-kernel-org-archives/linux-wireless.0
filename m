Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1BIRJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:09:29 -0500
Subject: Re: [PATCH v2] iwl3945: remove plcp check
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110209074606.GA5528@redhat.com>
References: <20110208090446.GA2490@redhat.com>
	 <1297180040.20613.39.camel@wwguy-ubuntu> <20110209063137.GD2184@redhat.com>
	 <20110209074606.GA5528@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:07:42 -0800
Message-ID: <1297271262.20613.66.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 23:46 -0800, Stanislaw Gruszka wrote:
> Patch fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=654599
>  
> Many users report very low speed problem on 3945 devices,
> this patch fixes problem, but only for some of them.
>  
> For unknown reason, sometimes after hw scanning, device is not able
> to receive frames at high rate. Since plcp health check may request
> hw scan to "reset radio", performance problem start to be observable
> after update kernel to .35, where plcp check was introduced.
> 
> Bug reporter confirmed that removing plcp check fixed problem for him.
>  
> Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
> Cc: stable@kernel.org  # 2.6.35+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> v1 -> v2
> Instead of tuning threshold remove the check completely
> 
looks good for just minimal changes

Wey



