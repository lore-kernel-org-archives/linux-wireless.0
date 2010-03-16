Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:1831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab0CPPeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 11:34:06 -0400
Received: by fg-out-1718.google.com with SMTP id 16so156695fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Mar 2010 08:34:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100316145507.GA2364@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
	 <20100316145507.GA2364@dhcp-lab-161.englab.brq.redhat.com>
Date: Tue, 16 Mar 2010 16:34:04 +0100
Message-ID: <6cf6b73e1003160834k3a5dbdf2gd34cfd3dfc72469d@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
From: Adel Gadllah <adel.gadllah@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/16 Stanislaw Gruszka <sgruszka@redhat.com>:
> Hi Adel

Hi,

> On Sun, Mar 14, 2010 at 07:44:59PM +0100, Adel Gadllah wrote:
>> From 83bf3f1dba41e3dccdef4fecfccb094559568342 Mon Sep 17 00:00:00 2001
>> From: Adel Gadllah <adel.gadllah@gmail.com>
>> Date: Sun, 14 Mar 2010 19:16:25 +0100
>> Subject: [PATCH] iwlwifi: Silence tfds_in_queue message
>>
>> Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
>> noisy message, that fills up the log very fast.
>>
>> The error seems not to be fatal (the connection is stable and
>> performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.
>
> Did you fill a bug report on http://bugzilla.intellinuxwireless.org/
> to allow Intel fix the real root of the issue. If not please do.
> You may CC me to bug report.

Done

> In general patch looks good for me.
>
> Cheers
> Stanislaw
>

Thanks,
Adel
