Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48407 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbYFXOPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 10:15:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KB9IU-0002fA-BU
	for linux-wireless@vger.kernel.org; Tue, 24 Jun 2008 14:15:02 +0000
Received: from iap-pxy-mow1.siemens.ru ([212.248.25.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 14:15:02 +0000
Received: from dbaryshkov by iap-pxy-mow1.siemens.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 14:15:02 +0000
To: linux-wireless@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by
 default
Date: Tue, 24 Jun 2008 14:05:31 +0000 (UTC)
Message-ID: <g3quvb$8sa$1@ger.gmane.org> (sfid-20080624_161538_236467_90BC9430)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
	<1214252588-30723-5-git-send-email-hmh@hmh.eng.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:

> Currently, radios are always enabled when their rfkill interface is
> registered.  This is not optimal, the safest state for a radio is to be
> offline unless the user turns it on.
> 
> Add a module parameter that causes all radios to be disabled when their
> rfkill interface is registered.  The module default is not changed so
> unless the parameter is used, radios will still be forced to their
> enabled state when they are registered.
> 
> The new rfkill module parameter is called "default_state".
> 

Why not add the possibility for each rfkill-enabled radio to supply it's 
default state?



-- 
With best wishes
Dmitry


