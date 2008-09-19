Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:21342 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYISM2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 08:28:55 -0400
Received: by fg-out-1718.google.com with SMTP id 19so549263fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 05:28:53 -0700 (PDT)
Date: Fri, 19 Sep 2008 16:28:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	LWML <linux-wireless@vger.kernel.org>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080919122850.GE7222@lenovo> (sfid-20080919_142859_409895_E004F72C)
References: <20080919115758.GD7222@lenovo> <1221826437.10419.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1221826437.10419.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Johannes Berg - Fri, Sep 19, 2008 at 02:13:57PM +0200]
| On Fri, 2008-09-19 at 15:57 +0400, Cyrill Gorcunov wrote:
| > Interrupt remapping could lead to NULL dereference in case of
| > kzalloc failed and memory leak in other way. So fix the
| > both cases.
| 
| wireless? Wrong mailing list?
| 
| johannes

Oh...sorry :( Of course should be LKML. Sorry again.

		- Cyrill -
