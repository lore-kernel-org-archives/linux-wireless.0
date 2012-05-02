Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63579 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2EBHIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 03:08:47 -0400
Received: by wgbdr13 with SMTP id dr13so309899wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 00:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
References: <20120422182928.GA2854@ritirata.org>
	<20120430145803.GE2630@ritirata.org>
	<20120430170337.GA2560@tuxdriver.com>
	<4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
	<CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
	<20120501183415.GG4316@ritirata.org>
	<20120501205616.GA2563@ritirata.org>
	<4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
Date: Wed, 2 May 2012 10:08:46 +0300
Message-ID: <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com> (sfid-20120502_090851_482504_6ED9300C)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
<meenakshi.venkataraman@intel.com> wrote:
> Hi Antonio,
>
>>> it seems so. It happens at least once at boot time.
>>> I will try wireless-testing and see what happens. Then I will apply your patch.
>>
>>The problem is there either with wireless-testing and with
>>wireless-testing+your_patch.
>>
>>If it can somehow help, I also got several stack trace regarding intel_iova
>>functions. But then the I got kernel panic and I was not able to copy the
>>messages.
>
> [MV] Depending on how you set it up, perhaps the stack trace was saved in one of the syslog files in /var/log/...
>
> Thanks!
> Meenakshi
>

Can you please re-run with debug=1 and send the whole log ?
This will give a better indication on when the issue occurs.
Thanks
