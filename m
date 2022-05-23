Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86461C433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 23 May 2022 13:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiEWNd6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 May 2022 09:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbiEWNcq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 May 2022 09:32:46 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE471A068
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2022 06:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1653312741; x=1684848741;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=uYKRNduKjRUbcPtvpysardVIVa6MZw81PjiPBOp8I3Y=;
  b=IeiKVfbLW4E3qs1yxWQlIsnFzeZUPHTaU9XQj+HbtbQns2VHPHoogt9h
   YiihN+J8cVTu6vJs6K9Iod6JqHJVGkWcKCoHa96MojowUyBaig3HaB3v7
   ooxtESn66Qb9PzvyRTGz8VGbU9MDmJv1tFvp5E88CTGqj7qONP3Xwkw4Q
   A=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 23 May 2022 06:31:57 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 06:31:57 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 23 May 2022 06:31:57 -0700
Received: from [10.216.30.28] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 23 May
 2022 06:31:55 -0700
Message-ID: <4d1a3d17-4950-e7f2-bc44-c7add9ed799b@quicinc.com>
Date:   Mon, 23 May 2022 19:01:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3] cfg80211: Increase akm_suites array size in
 cfg80211_crypto_settings
Content-Language: en-US
From:   Veerendranath Jakkam <quic_vjakkam@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <1653024702-5304-1-git-send-email-quic_vjakkam@quicinc.com>
 <a8a3b56b-5e82-28cb-bd61-e338bae25df2@quicinc.com>
 <12c8d629-86b0-1cd9-18f2-eeafccf36714@quicinc.com>
In-Reply-To: <12c8d629-86b0-1cd9-18f2-eeafccf36714@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 5/23/2022 6:57 PM, Veerendranath Jakkam wrote:
>
>
> Thanks Jeff. Fixed the suggested grammar nits in v5
>
*fixed in v4

--

veeru

