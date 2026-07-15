Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A037E5CB
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106049; cv=none; b=qUP3/h6EvHGLtdoLCRwNxhWBM7TZlUYDdbeV4ovS7hY7SaNnyaiZ5woMNiIeRV+8XdbL0HN4gOZFYbL8RsOqIPj8EBxFd9RNbmbwztbSWAm7kAvVx9nRYA2YKNhSp+sNB5F3Z9arltxjagyVHwPsPO8Dm6pylnB0DHv1Sf39zc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106049; c=relaxed/simple;
	bh=5VtbUyXNZDuhV6bSABJhftrGxCknDqtWcOIQUqrvTi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YaUMMixiajNQ6DLIRbq4mGeGW4Yxw5Wwkgc4VIyyVKc1AwHRU/OEMpic8QkQl0Nc/J/sIYCmZKiHWSzzrC5EjkJ1pvWd6VOd6iNOuyTqHJZuuai8w0BLWiBhqq7lzI56bvt6NpBwKXrDViia3yK7NN618WOETRE62V5c0nkKgtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jmu.edu.cn; spf=pass smtp.mailfrom=jmu.edu.cn; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jmu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jmu.edu.cn
Received: from Vostro-3710.lan (unknown [113.80.141.85])
	by smtp.qiye.163.com (Hmail) with ESMTP id 46448d459;
	Wed, 15 Jul 2026 17:00:36 +0800 (GMT+08:00)
From: Chukun Pan <amadeus@jmu.edu.cn>
To: lorenzo@kernel.org
Cc: Bo.Jiao@mediatek.com,
	amadeus@jmu.edu.cn,
	angelogioacchino.delregno@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	matthias.bgg@gmail.com,
	nbd@nbd.name,
	rex.lu@mediatek.com,
	ryder.lee@mediatek.com,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com,
	sujuan.chen@mediatek.com
Subject: Re: [PATCH mt76 v5 16/16] wifi: mt76: mt7996: Add SW path for HW-RRO v3.1
Date: Wed, 15 Jul 2026 17:00:30 +0800
Message-Id: <20260715090030.1535098-1-amadeus@jmu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <alc6xTe4uPIJHQy8@lore-desk>
References: <alc6xTe4uPIJHQy8@lore-desk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f6501aadf03a2kunm7c2e8de7748cb
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTRpOVh1ITEodQktKTx9CHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKSkhVQ0tVSk9KVUNOWVdZFhoPEhUdFFlBWU9LSFVCQklOS1
	VKS0tVSkJLQlkG

Hi,

> IIRC WED is not supported for HW RRO3.1 at the moment

Okay, seeing this commit, I mistakenly thought it meant support:
net: mediatek: wed: Introduce MT7992 WED support to MT7988 SoC

Sorry for the noise.

Thanks,
Chukun
