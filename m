Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xye1cg/3"
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BCE1A8
	for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2023 18:39:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F95C433C7;
	Thu, 23 Nov 2023 02:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700707198;
	bh=rRbIXqjq8DKBA6vW+7glleky65j8TQodsqrm6IeWtY0=;
	h=Date:From:To:Subject:From;
	b=xye1cg/3Q6K73LnW2xaH9xF9H8D6k3W8/A30CAZ1BFc2K3Y6Rz6Ebd9JeGiJKs7U2
	 vuBP3NPVQDCZLM50tZ7HjPdoobqzAHgsLE7nUU1aIp6K7h7hwDjKik7q8awy5otiIa
	 ycacZemFGYN4GnG/UdUTIPiDP4DZ8R9SVfZN5c9g=
Date: Wed, 22 Nov 2023 21:39:57 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: linux-wireless@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231122-cocky-cyan-trout-32c7cf@nitro>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to the new vger infrastructure. No action is
required on your part and there should be no change in how you interact with
this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
