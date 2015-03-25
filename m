Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50696 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbbCYPqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 11:46:54 -0400
Message-ID: <5512D86D.8020708@candelatech.com> (sfid-20150325_164657_959169_38B17CCB)
Date: Wed, 25 Mar 2015 08:46:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jose Antonio Delgado Alfonso <jose.delgado@aoifes.com>
CC: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: Dynamic channel Access
References: <CADxDmp50X2XnBjfk5qJKRH-n=1Cwagmjb_XyD+RJ4AgpPh-kjQ@mail.gmail.com> <CAEFj985wmiPwnF7rM1qCcO2K3X2yC_onO0AAMfm=9ytwpChzgg@mail.gmail.com> <etPan.542e8df5.6b8b4567.117@Okhwanui-Mac-mini.local> <55128DF0.6010109@aoifes.com> <5512D58B.6030204@aoifes.com>
In-Reply-To: <5512D58B.6030204@aoifes.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2015 08:34 AM, Jose Antonio Delgado Alfonso wrote:
> Hi all,
> 
> I would like to ask Qualcomm's collaborators about this topic.
> 
> We are trying to certify a AP product which uses QCA988x radio module.
> We are using the ath10k driver (kernel v3.17.8) and firmware from Ben
> Greear. We are trying to pass the Dynamic Channel test, which consists
> in setting the radio at 80MHz and, at the same time, setting other
> signal in the secondary channel. So far, the radio module does not
> reduce the bandwidth and remains transmitting at 80MHz.
> 
> Please, Does someone know if Dynamic Channel Access is really supported
> by ath10k driver in newest kernel versions?
> Or, does it also depends on the firmware version?

You could try testing with the upstream firmware and see if that works
any better?  Even if it is unstable under load, it should at least
be able to run long enough to do a feature test like this.

If it works on 10.1.467 upstream firmware but not on mine, then probably it is a regression
and I should be able to fix it.

Thanks,
Ben

> 
> Thanks in advance.
> 
> Regards,
> Jose Delgado
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

