Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE8AC433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Apr 2022 15:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389837AbiDUPHy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Apr 2022 11:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389929AbiDUPHo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Apr 2022 11:07:44 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39AF18
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2022 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650553494; x=1682089494;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mQKp/jMr3FcKjmXxKJnYzdG6TMr0zWV7HaL0JZGzmi0=;
  b=SXYbztJj6SiuHpUjkuimdRRkLfMONXKvl0N0CAzyDaX103qKkMmHixTJ
   2XF+f3hjDLTsx6tEogOGnG/pudGseMTfzRa5UO9eY46aiKKidOivwYMFd
   rSaOVHI6HTRJdBGzaK396HEX65lsqLqL2Sp0hIqhcC86usztH7SI2WCu7
   o=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 21 Apr 2022 08:04:54 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:04:53 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 21 Apr 2022 08:04:53 -0700
Received: from [10.110.114.17] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 21 Apr
 2022 08:04:53 -0700
Message-ID: <6306770e-586f-54dc-c12c-3e3caa8679be@quicinc.com>
Date:   Thu, 21 Apr 2022 08:04:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 1/2] ath11k: add support for extended wmi service bit
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
CC:     Baochen Qiang <quic_bqiang@quicinc.com>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
References: <20220401120948.1312956-1-quic_bqiang@quicinc.com>
 <20220401120948.1312956-2-quic_bqiang@quicinc.com>
 <4f421eab-1ace-51c6-e677-42b32b6afc56@quicinc.com>
 <87h76nogqt.fsf@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <87h76nogqt.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/20/2022 9:35 AM, Kalle Valo wrote:
>> I suspect Kalle can just apply these comments to his pending branch.
> 
> Did that now, please check:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=d98a4c9bd0b32824ad9ee2d24ecabb345edfaafe
> 

LGTM!
