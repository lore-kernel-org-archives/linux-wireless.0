Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:63289 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361Ab0CTSwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 14:52:07 -0400
From: Stefan Monnier <monnier@iro.umontreal.ca>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl3945 and power saving
Message-ID: <jwv8w9mddyn.fsf-monnier+inbox@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<1268804105.2446.620.camel@rchatre-DESK>
	<jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<1269017296.2446.1777.camel@rchatre-DESK>
	<jwvd3z010ar.fsf-monnier+inbox@gnu.org>
	<1269036564.2446.1887.camel@rchatre-DESK>
Date: Sat, 20 Mar 2010 14:52:03 -0400
In-Reply-To: <1269036564.2446.1887.camel@rchatre-DESK> (reinette chatre's
	message of "Fri, 19 Mar 2010 15:09:24 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Aha!  That's very interesting, then.  So, given that the previous naive
>> power-saving implementation worked well for me (and I presume other
>> users as well), would it be possible to use/provide that old naive
>> technique for 3945 and 4965?
> We could look into this. Could you please submit a request for this
> change to http://bugzilla.intellinuxwireless.org/ ?

Done.

> If there is a need for this then I think what can be done here is either
> use the current debugfs "sleep_level_override" or maybe some new one to
> get to the old behavior. Currently modifying this value will be ignored
> if power saving is marked as broken, as is done for 3945. I wonder if we
> can modify it such that user can change this setting even if power
> saving is marked as broken. This is maybe something you can try out.

Thanks, I'm going to take a look at it,


        Stefan
