Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:34977
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZCQEpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 00:45:32 -0400
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7] (unknown [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTPSA id A3317252A7C
	for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 00:45:26 -0400 (EDT)
Message-ID: <49BF2AE4.6010604@erley.org> (sfid-20090317_054538_067382_BE90214D)
Date: Tue, 17 Mar 2009 00:45:24 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rfc] Implement ath9k mesh point operation
References: <49BED464.2010904@erley.org>
In-Reply-To: <49BED464.2010904@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, I was able to do the development of this thanks to hardware 
donated by Johannes Berg (b43 card that was used as a baseline known
working device) and an ath9k card donated by Oxford TEC[1].  What's 
the best way to add this 'credit' to the commit, or is it not 
appropriate?

Pat Erley

[1] http://www.oxfordtec.com/
