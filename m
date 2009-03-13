Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:49653 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZCMASb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 20:18:31 -0400
Received: by fxm24 with SMTP id 24so2431128fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 17:18:27 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1236902218.13039.8.camel@maxim-laptop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
	 <1236824994.7177.3.camel@maxim-laptop>  <1236880246.13699.17.camel@rc-desk>
	 <1236892879.30325.7.camel@maxim-laptop>
	 <1236897665.3911.8.camel@abhi-desktop>
	 <1236902218.13039.8.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 02:18:13 +0200
Message-Id: <1236903493.22539.2.camel@maxim-laptop> (sfid-20090313_011835_089732_3CB66A09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small slightly out of thread question if you don't mind:

Quite long time ago I noticed that iwl3945 doesn't show noise level
anymore. it always tells that it is -127dBm.

I did see noise levels some long time ago with iwll3945.

Is this a bug or feature?

Best regards,
	Maxim Levitsky

