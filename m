Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE99C433F5
	for <linux-wireless@archiver.kernel.org>; Fri,  6 May 2022 18:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388909AbiEFTAC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 May 2022 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiEFTAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 May 2022 15:00:00 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A88033A2C
        for <linux-wireless@vger.kernel.org>; Fri,  6 May 2022 11:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1651863377; x=1683399377;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qsJCVDIq75HwaCW+DhzSJRaUi8sL0u49qU19KlIr1Io=;
  b=cweRJsqUjgTs7d9r8A0f97fY5bBf9tqRvVLlN9XksYpSFb63PxTRJ9c1
   KB/hELXQlnIQ4TwRKBD7NLLuxUhpstMwnOgMjSPRCgbjULDlNT4T5cXQQ
   t1rtoNxIdZWS9r4mOcJrudR5liDPGqsi4VuSgAb/d+FzibfeSS5OnqN0R
   U=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 May 2022 11:56:17 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:56:17 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 6 May 2022 11:56:16 -0700
Received: from [10.110.125.2] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 6 May 2022
 11:56:16 -0700
Message-ID: <56483fa2-c743-86c8-8790-db00ec79e331@quicinc.com>
Date:   Fri, 6 May 2022 11:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] rtw88: adjutst adaptivity option to 1
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>, <tony0620emma@gmail.com>,
        <kvalo@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <timlee@realtek.com>
References: <20220505090745.158892-1-pkshih@realtek.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220505090745.158892-1-pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 5/5/2022 2:07 AM, Ping-Ke Shih wrote:
> From: Chin-Yen Lee <timlee@realtek.com>
> 
> Fine tune algorithm of adaptivity sensitivity to avoid disconnecting
> from AP suddenly in field.
> 
> Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

nit: s/adjutst/adjust/ in subject
