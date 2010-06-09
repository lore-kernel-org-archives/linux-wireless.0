Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37000 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0FITRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 15:17:52 -0400
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: reinette chatre <reinette.chatre@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100609.121207.193693646.davem@davemloft.net>
References: <1276102692.1835.14610.camel@rchatre-DESK>
	 <20100609.103326.189711649.davem@davemloft.net>
	 <1276110641.1835.14891.camel@rchatre-DESK>
	 <20100609.121207.193693646.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:17:42 -0700
Message-ID: <1276111062.1835.14914.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 12:12 -0700, David Miller wrote:
> Upstream 2.6.34 vanilla.

ok - the firmware assert you are encountering is in the station
management code which received significant rework in 2.6.35. Could you
please try latest linux-2.6 (since there are some issues with
2.6.35-rc2)?

Reinette


